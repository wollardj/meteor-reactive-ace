Template.mandrill_ace.rendered = ->
    # Make sure ace is aware of the fact the things might have changed.
    MandrillAce.getInstance()._attachAce()
