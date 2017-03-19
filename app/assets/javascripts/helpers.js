this.Helpers = {
    getObjectsFromLocation: function(url) {
        $.ajax({
            type: 'get',
            dataType: 'script',
            url: url
        });
    }
}