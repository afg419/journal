var extractEntry = function (){
  $('.submit-entry').on('click', function(){
    data = entryContent();
    $.ajax({
      type: "POST",
      url: "/api/v1/journal_entries",
      data: data,
      success: function(msg){
        lockPost(msg);
        doAnalytics(data);
      },
      error: function(error_message){
        console.log(error_message.responseText)
      }
    });
  })
}

var doAnalytics = function(data){
  debugger
  $.ajax({
    type: "GET",
    url: "/api/v1/alert_analytics",
    data: data,
    success: function(msg){
      if(msg.reply){
        postAlert(msg);
      }
    },
    error: function(error_message){
      console.log(error_message.responseText)
    }
  });
}


var postAlert = function(msg){
  alert(msg)
}


var entryContent = function(){
  var values = {};
  $('.slider').each(function(index, slide){
    var emotion = slide.name
    values[emotion] = slide.value
  })

  values["tag"] = $('#tag')[0].value
  values["body"] = $('#journal_entry_body')[0].value
  values["user_id"] = $('.user').attr('name')
  return values
}

var lockPost = function(msg){
  if (msg.created == "success"){
    $('.slider').each(function(index, slide){
      $(slide).attr('readonly', "readonly")
    })
    $('.entry-form').toggleClass('active')
    $('.entry-form').toggleClass('inactive')
    $('#tag').attr('readonly', "readonly")
    $('#journal_entry_body').attr('readonly', "readonly")
    $('#header').empty()
    $('#header').append("Your Journal Entry has been Submitted")
    $('#new-entry-main-button').empty()
    $('#new-entry-main-button').append("<a href='/dashboard'>To Dashboard</a>")
  }else{
    console.log("message was not created")
  }
}
