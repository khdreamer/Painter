var def = "brush";
var selected = def;
var toolbox_h = $(window).height() - 8;
var zoomScales = [0.125, 0.167, 0.25, 0.33, 0.5, 1, 2, 3, 4, 5, 6];
var zoomIdx = 5;
var panel_content = {

  "brush": [
    {"name": "size", "type": "slider", "range": [1, 1, 100]}
  ],
  "eraser": [
    {"name": "size", "type": "slider", "range": [1, 1, 100]}
  ],
  "text": [
    {"name": "size", "type": "input", "unit": "pt"}
  ],
  "spray": [
    {"name": "size", "type": "slider", "range": [1, 1, 100]},
    {"name": "hardness", "type": "slider", "range": [1, 1, 50]}
  ],
  "zoom": [
    {"name": "type", "type": "select", "options": {"zoom in": "in", "zoom out": "out"}}
  ]

};
var params = {

  "size": {
    "brush": 9,
    "text": 12,
    "eraser": 9,
    "spray": 9,
    "zoom": zoomScales[zoomIdx]
  },
  "hardness": {
    "spray": 12
  },
  "type": {
    "zoom": "in"
  }

}

$(function(){

  // initial draggable
  $("canvas#main").draggable();
  $("canvas#main").draggable("disable");

  // color picker
  $('#colorpicker').ColorPicker({
    flat: true,
    color: "#000000",
    onChange: function(hsb, hex, rgb) {
      $('div.color').css('backgroundColor', '#' + hex);
      sketch.changeColor("ff" + hex);
    },
    onShow: function(colpkr) {
      var color = $('div.color').css("backgroundColor");
      $(colpkr).ColorPickerSetColor(color);
    }

  }).hide();

  // setup size and stuff
  $("div#toolbox").height(toolbox_h);
  
  // click event
  var pressTimer;
  $("div.tool_btn").mouseup(function(){

    clearTimeout(pressTimer); // stop timer for long press

  }).mousedown(function(){ // long press event

    // select the button
    $("div.panel").remove();
    selected = $(this).attr("type");;
    console.log(selected);
    $(".selected").removeClass("selected");
    $(this).addClass("selected");

    // dragging
    if(selected == "drag"){

      $("canvas#main").draggable("enable");

    }
    else{

      $("canvas#main").draggable("disable");

    }

    // set timer for long press
    var top = $(this).position().top + 2;
    pressTimer = window.setTimeout(function(){

      // append panel
      createPanel(selected, function(){

        $("div.panel").css("top", top);

      });
      
    }, 400);

  });

  // choose color event
  $("div.color").click(function(){

    $('#colorpicker').toggle();

  });

  // zooming
  $("#sketch_wrapper").click(function(){

    console.log("canvas clicked");
    if( selected == "zoom" ){

      console.log(params.type.zoom);
      // check type
      if(params.type.zoom == "in") zoomIdx++;
      else if(window.params.type.zoom == "out") zoomIdx--;
      else console.log("Huston, we got a probzoom.");

      // check overflow
      max = zoomScales.length;
      console.log(max);
      if(zoomIdx >= max) zoomIdx = max - 1;
      if(zoomIdx < 0) zoomIdx = 0;
      console.log(zoomIdx);
      
      params.size.zoom = zoomScales[zoomIdx];

      var w = params.size.zoom * sketch_w;
      var h = params.size.zoom * sketch_h;
      var l = ($("#sketch_wrapper").width() - w)/2;
      var t = ($("#sketch_wrapper").height() - h)/2;

      $("canvas#main").css({

        "width": w,
        "height": h,
        "left": l,
        "top": t

      });

    }

  });

});

var createPanel = function(type, callback){

  var panel = document.createElement("div");
  panel.className = "panel";

  // create content of the panel
  var content = panel_content[type];
  for(var i = 0; i < content.length; i++){
    var ele = content[i];
    var name = ele.name;

    if(ele.type == "slider"){ // create slider

      var $slider = $( "<div>" ).attr("id", name);
      var $slider_wrapper = $( "<div>" ).attr("id", name + "_wrapper" );

      // set up for slider
      $slider.slider({

        range: "min",
        value: params[name][type],
        min: ele.range[0],
        max: ele.range[2],
        slide: function(event, ui){
          
          // change size
          var name = this.id;
          $(this).siblings("p#value").html(ui.value);
          params[name][type] = ui.value;

        }

      });

      $slider_wrapper.append($("<p>" + name + ":</p>"))
                     .append($slider)
                     .append($("<p id='value'>" + params[name][type] + "</p>"));
      $(panel).append($slider_wrapper);
      
    }
    else if(ele.type == "input"){ // create input

      var $input_wrapper = $( "<div>" ).attr("id", name + "_wrapper" );
      var $input = $( "<input type=\"number\" \
                       name=\"" + name + "\" \
                       value=\"" + params[name][type] + "\">" ).attr("id", name);
      $input.change(function(){

        if($(this).val() !== "" && $(this).val() > 0) {
          
          params[name][type] = $(this).val();
          console.log(params[name][type]);

        }
        else {

          $(this).val(params[name][type]);

        }
        
      });

      $input_wrapper.append($("<p>" + name + ":</p>"))
                     .append($input)
                     .append($("<p>" + ele.unit + "</p>"));
      $(panel).append($input_wrapper);

    }
    else if(ele.type == "select"){ // create select

      var $select_wrapper = $( "<div>" ).attr("id", name + "_wrapper" );
      var $select = $( "<select>" ).attr("id", name);
      for(var o in ele.options){

        var $o = $("<option>").html(o).attr("value", ele.options[o]);
        $select.append($o);

      }
      $select.val(params.type[type]);
      $select.change(function(){

        var sel = $(this).find("option:selected").val();
        params.type[type] = sel;

        // change icon
        var sel_str = $(this).find("option:selected").html();
        sel_str = sel_str.replace(" ", "");
        $(".tool_btn.lsf-icon.selected").attr("icon", sel_str);

      });
      $select_wrapper.append($select)
      $(panel).append($select_wrapper);

    }
    else{

      console("Then what the hell is this element!");

    }
  }

  $("body").append($(panel));
  callback();


}
  





    



