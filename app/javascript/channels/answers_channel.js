import consumer from './consumer';

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create('AnswersChannel', {
    connected() {
      console.log('Connected to the answer list');
    },

    disconnected() {},

    received(data) {
      if (gon.user_id != data.user_id) {
        $('.answers').append(
          `<div id="answer-${data.id}"><p>${data.body}</p></div>`
        );
      }
    },
  });
});
