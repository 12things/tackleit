// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.observe("dom:loaded", function(event) {
  if($('notice')) { 
    $('notice').highlight();
    $('notice').fade({duration: 0.5, delay: 10});
  }
});
