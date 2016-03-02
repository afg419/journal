var extractEntry = function (){
  $('.submit-entry').on('click', function(){
    var values = {};
    $('.slider').each(function(index, slide){
      var emotion = slide.name
      values[emotion] = slide.value
    })

    values["tag"] = $('#tag')[0].value
    values["body"] = $('#journal_entry_body')[0].value
    values["user_id"] = $('.user').attr('name')

    $.ajax({
      type: "POST",
      url: "/api/v1/journal_entries",
      data: values,
      success: function(msg){
        lockPost(msg);
      },
      error: function(error_message){
        console.log(error_message.responseText)
      }
    });
  })
}


var lockPost = function(msg){
  if (msg.created == "success"){
    $('.slider').each(function(index, slide){
      $(slide).attr('readonly', "readonly")
      $(slide).css('background-color', "black")
    })
    $('#tag').attr('readonly', "readonly")
    $('#tag').css('color', "#85A7D0")
    $('#journal_entry_body').attr('readonly', "readonly")
    $('#journal_entry_body').css('color', "#85A7D0")
    $('#header').empty()
    $('#header').append("Your Journal Entry has been Submitted")
    $('#new-entry-main-button').empty()
    $('#new-entry-main-button').append("<a href='/dashboard'>To Dashboard</a>")
  }else{
    console.log("message was not created")
  }
}
