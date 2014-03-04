var sketch;
var sketch_name = "Untitled";
var sketch_w = 454;
var sketch_h = 340;

$(function(){

  // setup setup
  var l = ($(window).width() - $("#file_setup").outerWidth())/2;
  var t = ($(window).height() - $("#file_setup").outerHeight())/2;
  $("#file_setup").css({

    "left": l,
    "top": t

  });
  $("div#sketch_wrapper").width($(window).width() - 241).height($(window).height());

  $("#file_setup #ok input[type=button]").click(function(){

    sketch_w = $("#file_setup input[name=width]").val();
    sketch_h = $("#file_setup input[name=height]").val();
    sketch_name = $("#file_setup input[name=name]").val();



    // position
    var l = ($("#sketch_wrapper").width() - sketch_w)/2;
    var t = ($("#sketch_wrapper").height() - sketch_h)/2;
    $("canvas").css({

      "left": l,
      "top": t,
      "background": "url(images/transp_bg.png)",
      "backgroundColor": "#fff"

    });

    // load sketch
    getSketch("main");
    sketch.setupDone();

    $("#file_setup_wrapper").hide();

  });


});

var getSketch = function(id_name){

  sketch = Processing.getInstanceById(id_name);
  if(sketch == null){

    setTimeout(function(){

      getSketch(id_name);

    }, 250);
  }

}
