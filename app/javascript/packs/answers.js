$(document).on('turbolinks:load', function () {
  $('.answers').on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('form.new-answer')
    .on('ajax:success', function (e) {
      const answer = e.detail[0];
      if (typeof answer.body !== 'undefined') {
        $('.answers').append('<p class="answer_body">' + answer.body + '</p>');
      }
      $(this[1]).val('');
    })
    .on('ajax:error', function (e) {
      const errors = e.detail[0];

      $.each(errors, function (index, value) {
        $('.answer-errors').append('<p class="answer_error">' + value + '</p>');
      });
    });
});
