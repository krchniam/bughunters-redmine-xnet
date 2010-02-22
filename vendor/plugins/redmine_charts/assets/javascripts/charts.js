function charts_earlier() {
    $('range_offset').value = parseInt($('range_offset').value) + 1;
    $('range_offset').form.submit();
}

function charts_later() {
    $('range_offset').value = parseInt($('range_offset').value) - 1;
    if($('range_offset').value < 1) {
        $('range_offset').value = 1;
    }
    $('range_offset').form.submit();
}

function charts_previous() {
    $('page').value = parseInt($('page').value) - 1;
    if($('page').value < 1) {
        $('page').value = 1;
    }
    $('page').form.submit();
}

function charts_next() {
    $('page').value = parseInt($('page').value) + 1;
    $('page').form.submit();
}

function save_image() { 
  with(window.open('', charts_to_image_title).document) {
    write('<html><head><title>' + charts_to_image_title + '<\/title><\/head><body><img src="data:image/png;base64,' + $$('#' + charts_to_image_id)[0].get_img_binary() + '" /><\/body><\/html>')
  }
}
