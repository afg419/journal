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

    debugger

    $.ajax({
      type: "POST",
      url: "/journal_entries",
      data: values,
      success: function(msg){
        renderPost(msg);
      },
      error: function(error_message){
        console.log(error_message.responseText)
      }
    });


  })
}
