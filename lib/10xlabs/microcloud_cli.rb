require 'commander'
require 'commander/delegates'

#
# snippet from commander:lib/commander/import.rb needed when manually calling
# run! instead of relying on at_exit { run! } (sic!).
#
include Commander::UI
include Commander::UI::AskForClass
include Commander::Delegates

$terminal.wrap_at = HighLine::SystemExtensions.terminal_size.first - 5 rescue 80 if $stdin.tty?

# commands
require '10xlabs/commands/lab_create_command'
require '10xlabs/commands/lab_release_command'