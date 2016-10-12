$(function() { $.support.transition = false; })

with ($('.facet-filter')) {

  find('form').submit(function() {
    return false;
  });

  find('input').keyup(function() {
    var v = $(this).val(), f,
        c = function(e) { return e.hasClass('collapse'); };

    if (v) {
      v = v.toLowerCase();

      f = function(e) {
        if (e.find('a').text().toLowerCase().indexOf(v) < 0) {
          c(e) ? e.collapse('hide') : e.hide();
        }
        else {
          c(e) ? e.collapse('show') : e.show();
        }
      };
    }
    else {
      f = function(e) {
        c(e) ? e.collapse('hide') : e.show();
      }
    }

    $(this).closest('.panel').find('li').each(function(i, e) {
      f($(e));
    });
  });

  find('.glyphicon-remove').click(function() {
    var i = $(this).closest('.facet-filter').find('input');

    i.val('');
    i.keyup();
    i.focus();
  });

  on('shown.bs.collapse', function() {
    $(this).find('input').focus();
  });

}
