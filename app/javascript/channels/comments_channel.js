import consumer from './consumer';

$(document).on('turbolinks:load', function () {
  const questionId = $('#question').attr('data-question-id');
  consumer.subscriptions.create(
    { channel: 'CommentsChannel', question_id: questionId },
    {
      connected() {
        console.log('Connected to the question ' + questionId);
      },

      disconnected() {},

      received(data) {
        $('.comments-list').append(
          `<div id="comment-${data.id}"><p>${data.body}</p></div>`
        );
      },
    }
  );
});
