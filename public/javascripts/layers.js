var layer_count = 1;
var layers_created = 1;

var bind_layer_event = function($layer){

  $layer.click(function(){

    console.log("c");
    $(".current").removeClass("current");
    $(this).addClass("current");
    var idx = Math.abs($(".layer").index($(".layer.current")[0]) - layer_count + 1);
    sketch.changeCurrentLayerIdx(idx);
    
  });

}

var create_layer = function(){

  // add layer to layer panel
  var $layer = $("<li class=\"layer\">layer" + layers_created + "</li>");
  $layer.insertBefore(".current");
  $(".current").removeClass("current");
  $layer.addClass("current");
  bind_layer_event($layer);

  // make the sketch create a new layer
  var idx = Math.abs($(".layer").index($(".layer.current")[0]) - layer_count + 1);
  sketch.createLayer(idx);

  layer_count++;
  layers_created++;

}

var delete_layer = function(){

  if(layer_count > 1){

    var $next;
    var idx = Math.abs($(".layer").index($(".layer.current")[0]) - layer_count + 1);
    if($(".layer.current").is(".layer:last")) $next = $(".layer.current").prev();
    else $next = $(".layer.current").next();
    $(".layer.current").remove();
    $next.addClass("current");
    sketch.deleteLayer(idx);
    layer_count--;

  }
  
}

var layer_functions = {

  "create": create_layer,
  "delete": delete_layer

}

$(function(){

  // setup
  $("div#layers ul").height($("div#layers").height()-$("div#layers #layer_func").outerHeight()-2);
    // -1 is for the 2 borders

  // layers panel: sortable config
  var which = -1;
  var toWhere = -1;
  $("div#layers ul").sortable({ 
    containment: "parent", 
    tolerance: "pointer",
    start: function(event, ui){

      // the adding and absolute stuff is because the index is in different order than layer order
      which = Math.abs($("div#layers ul li.layer").index(ui.item[0]) - layer_count + 1);

    },
    stop: function(event, ui){

      toWhere = Math.abs($("div#layers ul li.layer").index(ui.item[0]) - layer_count + 1);
      sketch.changeLayerOrder(which, toWhere);
      $(".current").removeClass("current");
      ui.item.addClass("current");

    }

  });

  // button event
  $("#layer_func .layer_btn").mousedown(function(){

    $(this).addClass("selected");

  }).mouseup(function(){
  
    $(this).removeClass("selected");
    var type = $(this).attr("type");
    layer_functions[type]();

  }).mouseleave(function(){
  
    $(this).removeClass("selected");

  });

  // layer event
  bind_layer_event($("li.layer"));

});
