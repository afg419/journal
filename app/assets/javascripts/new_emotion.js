var revealHideNewEmotion = function(){
  $('.add-emotion span').toggleClass("hide")
}

var listenForRemove = function(){
  $('.remove').on('click',function(){
    removeEmotion($(this)[0].name);
  })
}

var createNewEmotion = function(){
  var name = $('#emotion-name')[0].value || $('#user_emotion_prototype_id')[0].value
  var description =$('#emotion-description')[0].value
  var data = {name: name, description: description}
  $.ajax({
    type: "POST",
    url: "/api/v1/emotions",
    data: data,
    success: function(msg){
      if (msg.reply == "created"){
        $('.emotion-sliders').append(slide(name, msg.description, msg.color));
        revealHideNewEmotion();
        listenForRemove();
      } else {
        alert("Sorry, " + msg.reply)
      }
    },
    error: function(error_message){
      console.log(error_message.responseText)
    }
  });
}

var removeEmotion = function(name){
  $.ajax({
    type: "DELETE",
    url: "/api/v1/emotions/" + name,
    success: function(msg){
      if (msg.reply == "removed"){
        $("#" + name).empty();
              } else {
        alert("Sorry, " + msg.reply)
      }
    },
    error: function(error_message){
      console.log(error_message.responseText)
    }
  });
}
