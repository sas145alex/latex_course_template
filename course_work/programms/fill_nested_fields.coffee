fillNestedFields = ->
  $('select[id$=author_id]').on 'change', (e) ->
    value = $(this).find('option:selected').val()
    name = $(this).attr('name').match(/attributes]\[(\d+)\]/)
    timestamp = name[name.length - 1]
    $.ajax
      url: '/fill_author_form'
      type: 'POST'
      dataType: 'script'
      data: { author_id: value, timestamp: timestamp }
