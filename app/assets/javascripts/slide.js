var slide = function(name, description, color){
  return ("<div class='emotion-text', id='"+name+"' >" +
  "<p>"+
    "<a href='#', class='description'><span><strong>" + name.capitalize() + ": </strong>" + description + "</span>?</a><span style='padding-left: 1em'></span>" + name.capitalize() +
    "<a href='#', class='remove' name='" + name + "'> Remove</a>" +
  "</p>" +
  "<input style='background-color: "+ color + "' class='slider " + name + "-slide' type='range' name='"+name+"' min='0' max='10' value='0'><br>" +
  "</div>")
}
