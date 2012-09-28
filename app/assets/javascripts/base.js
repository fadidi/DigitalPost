// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
  $('.carousel').carousel();

  // allow elements in a row to be the same height
  $('.equal-heights-1').equalHeights();
  $('.equal-heights-2').equalHeights();
  $('.equal-heights-3').equalHeights();

  // add datepicker popup
  $('.datepicker').datepicker({
    format: 'yyyy-mm-dd'
  });

  // apply correct bootstrap styles to form error fields
  $('.field_with_errors').closest('.control-group').addClass('error');

  /*********************************************/
  /* jquery.timeago binding */
  $.timeago.settings.allowFuture = true;
  $('time.timeago').timeago();  

  /***********************************************/
  /* bootstrap fixes */

  // thumbnails in fluid grid
  $('.row-fluid ul.thumbnails li.span6:nth-child(2n + 3)').css('margin-left','0px');
  $('.row-fluid ul.thumbnails li.span4:nth-child(3n + 4)').css('margin-left','0px');
  $('.row-fluid ul.thumbnails li.span3:nth-child(4n + 5)').css('margin-left','0px'); 
  $('.row-fluid ul.thumbnails li.span2:nth-child(5n + 7)').css('margin-left','0px'); 

  /********************************************/
  /* bootstrap bindings */

  // tooltips
  $('[rel=tooltip]').tooltip();

  // popover
  $('[rel=popover]').popover();

});
