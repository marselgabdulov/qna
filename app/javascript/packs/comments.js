$(document).on('turbolinks:load', function () {
  $('.add-comment-link').on('click', function (e) {
    e.preventDefault();
    $(this).hide();
    $(this)
      .closest('.comments')
      .find('form.comment-form')
      .removeClass('hidden');
  });
});
