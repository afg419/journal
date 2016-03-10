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
  $.ajax({
    type: "GET",
    url: "/api/v1/alert_analytics",
    data: data,
    success: function(msg){
      if(msg.reply){
        postAlert();
      }
    },
    error: function(error_message){
      console.log(error_message.responseText)
    }
  });
}


var postAlert = function(){
  $('.js-alert').append(" (!)")
  $('.js-alert').css("color","white")
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
    $('#header').empty();
    $('#header').append("Your Journal Entry has been Submitted")
    $('#new-entry-main-button').empty();
    $('#new-entry-main-button').append("<a href='/dashboard' class='add-new-emotion btn btn-default' >To Dashboard</a>")
    $(".add-emotion").empty();
    $(".remove").empty();
  }else{
    console.log("message was not created")
  }
}

function proRangeSlider(sliderid, outputid) {
  var x = $("#"+sliderid)[0].value;
  $("#"+outputid).empty();
  $("#"+outputid).append(x);
}
