# -*- coding: utf-8 -*-
# Copyright (C) 2009-2013  Roman Zimbelmann <hut@lavabit.com>
# This configuration file is licensed under the same terms as ranger.
# ===================================================================
# This file contains ranger's commands.
# It's all in python; lines beginning with # are comments.
#
# Note that additional commands are automatically generated from the methods
# of the class ranger.core.actions.Actions.
#
# You can customize commands in the file ~/.config/ranger/commands.py.
# It has the same syntax as this file.  In fact, you can just copy this
# file there with `ranger --copy-config=commands' and make your modifications.
# But make sure you update your configs when you update ranger.
#
# ===================================================================
# Every class defined here which is a subclass of `Command' will be used as a
# command in ranger.  Several methods are defined to interface with ranger:
#   execute(): called when the command is executed.
#   cancel():  called when closing the console.
#   tab():     called when <TAB> is pressed.
#   quick():   called after each keypress.
#
# The return values for tab() can be either:
#   None: There is no tab completion
#   A string: Change the console to this string
#   A list/tuple/generator: cycle through every item in it
#
# The return value for quick() can be:
#   False: Nothing happens
#   True: Execute the command afterwards
#
# The return value for execute() and cancel() doesn't matter.
#
# ===================================================================
# Commands have certain attributes and methods that facilitate parsing of
# the arguments:
#
# self.line: The whole line that was written in the console.
# self.args: A list of all (space-separated) arguments to the command.
# self.quantifier: If this command was mapped to the key "X" and
#      the user pressed 6X, self.quantifier will be 6.
# self.arg(n): The n-th argument, or an empty string if it doesn't exist.
# self.rest(n): The n-th argument plus everything that followed.  For example,
#      If the command was "search foo bar a b c", rest(2) will be "bar a b c"
# self.start(n): The n-th argument and anything before it.  For example,
#      If the command was "search foo bar a b c", rest(2) will be "bar a b c"
#
# ===================================================================
# And this is a little reference for common ranger functions and objects:
#
# self.fm: A reference to the "fm" object which contains most information
#      about ranger.
# self.fm.notify(string): Print the given string on the screen.
# self.fm.notify(string, bad=True): Print the given string in RED.
# self.fm.reload_cwd(): Reload the current working directory.
# self.fm.thisdir: The current working directory. (A File object.)
# self.fm.thisfile: The current file. (A File object too.)
# self.fm.thistab.get_selection(): A list of all selected files.
# self.fm.execute_console(string): Execute the string as a ranger command.
# self.fm.open_console(string): Open the console with the given string
#      already typed in for you.
# self.fm.move(direction): Moves the cursor in the given direction, which
#      can be something like down=3, up=5, right=1, left=1, to=6, ...
#
# File objects (for example self.fm.thisfile) have these useful attributes and
# methods:
#
# cf.path: The path to the file.
# cf.basename: The base name only.
# cf.load_content(): Force a loading of the directories content (which
#      obviously works with directories only)
# cf.is_directory: True/False depending on whether it's a directory.
#
# For advanced commands it is unavoidable to dive a bit into the source code
# of ranger.
# ===================================================================

from ranger.api.commands import *
import curses
import sys
import base64
import subprocess

# CUSTOM COMMANDS

class quickLook(Command):
    """:quicklook
    """

    context = 'browser'

    def execute(self):
        self.fm.execute_file(
                files = [f for f in self.fm.thistab.get_selection()],
                app = 'ql',
                flags = 'f')

class pro(Command):
    """:pro <query>
    """

    context = 'browser'

    def execute(self):
        command = ['pro', 'search', self.rest(1)]
        loc = subprocess.check_output(command)
        self.fm.cd(str(loc).rstrip())

class app(Command):
    """:app
    """

    context = 'browser'

    def execute(self):
        action = ['mv', '-f', self.fm.thisfile.path, '/Applications']
        self.fm.execute_command(action)

class trash(Command):
    """:trash [-q]

    Moves the selected files to the trash bin using Ali Rantakari's 'trash'
    program. Optionally takes the -q flag to suppress listing the files
    afterwards.
    """

    def execute(self):

        # Calls the trash program
        action = ['trash']
        action.extend(f.path for f in self.fm.thistab.get_selection())
        self.fm.execute_command(action)

        # TODO: check if the trashing was successful.

        # Echoes the basenames of the trashed files
        if not self.rest(1) == "-q":
            names = []
            names.extend(f.basename for f in self.fm.thistab.get_selection())
            self.fm.notify("Files moved to the trash: " + ', '.join(map(str, names)))
