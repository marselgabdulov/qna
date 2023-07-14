import consumer from './consumer';

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create('QuestionsChannel', {
    connected() {
      console.log('Connected to the question list');
    },

    disconnected() {},

    received(data) {
      $('.questions-list').append(
        `<p><a href="/questions/${data.id}">${data.title}</a><p>`
      );
    },
  });
});
