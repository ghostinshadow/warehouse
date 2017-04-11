this.Helpers = {
    getObjectsFromLocation: function(url) {
        $.ajax({
            type: 'get',
            dataType: 'script',
            url: url
        });
    },
    sendAjaxRequest: function(url, params) {
        $.ajax({
            type: 'get',
            dataType: 'script',
            url: url,
            data: {
                'filter': params
            }
        });
    }
}