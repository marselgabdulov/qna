$(document).on('turbolinks:load', function () {
  $('.question').on('click', '.edit-question-link', function (e) {
    e.preventDefault();
    $(this).hide();
    $('#question-form').removeClass('hidden');
  });

  $('form.new-question').on('ajax:error', function (e) {
    const errors = e.detail[0];
    console.log(errors);
    $.each(errors, function (index, value) {
      $('.question-errors').append(
        '<p class="question_error">' + value + '</p>'
      );
    });
  });
});
