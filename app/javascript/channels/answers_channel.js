import consumer from './consumer';

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create('AnswersChannel', {
    connected() {
      console.log('Connected to the answer list');
    },

    disconnected() {},

    received(data) {
      $('.answers').append(
        `<div id="answer-${data.id}"><p>${data.body}</p></div>`
      );
    },
  });
});
