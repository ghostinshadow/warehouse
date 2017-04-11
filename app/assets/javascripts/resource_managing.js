var count = 1;

function removeDeviceConfig(num) {
    $(".device_" + num).remove();
    count -= 1;
};

function getLocationObjects(associationId, url) {
    $.ajax({
        type: 'get',
        dataType: 'script',
        url: url,
        data: {
            association_id: associationId
        }
    });
}

function addDeviceMapping(url) {
    getLocationObjects(count, url);
    count += 1;
}


$(document).ready(function() {
    $('.datepicker').datepicker({orientation: "bottom"});
    $(".form-actions").hide();
})

$(".input_templates").bind("DOMSubtreeModified", function() {
    if ($(".input_templates").children().length === 0) {
        $(".form-actions").hide();
    } else {
        $(".form-actions").show();
    }
})