var slide = function(name, description, color){

  return ("<div class='emotion-text', id='"+name+"' >" +
  "<p>"+
    "<a href='#', class='description'><span><strong>"+ name.capitalize() + ": </strong>" + description + "</span>?</a><span style='padding-left: 1em'></span><span>" + name.capitalize() + ": <span id='output-"+ name +"'>0</span></span>" +
    "<a href='#', class='remove' name='" + name + "'> Remove</a>" +
  "</p>" +
  "<input id='input-"+name+"' " + "oninput=proRangeSlider(this.id," + "'output-"+ name+ "'" + ")" + "  style='background-color: "+ color + "' class='slider " + name + "-slide' type='range' name='"+name+"' min='0' max='9' value='0'><br>" +
  "</div>")
}
