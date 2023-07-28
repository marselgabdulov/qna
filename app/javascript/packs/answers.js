$(document).on('turbolinks:load', function () {
  $('.answers').on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('.answers').on('ajax:success', '.voting-buttons', function (e) {
    var answer = e.detail[0];
    $(`#answer-${answer.id} .voting-buttons`).hide();
    $(`#answer-${answer.id} .revote`).show();
    $(`#answer-${answer.id} .raiting`).html(answer.raiting);
  });

  $('.answers').on('ajax:success', '.revote', function (e) {
    var answer = e.detail[0];
    $(`#answer-${answer.id} .voting-buttons`).show();
    $(`#answer-${answer.id} .revote`).hide();
    $(`#answer-${answer.id} .raiting`).html(answer.raiting);
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
      console.log(e);
      const errors = e.detail[0];

      $.each(errors, function (index, value) {
        $('.answer-errors').append('<p class="answer_error">' + value + '</p>');
      });
    });
});
