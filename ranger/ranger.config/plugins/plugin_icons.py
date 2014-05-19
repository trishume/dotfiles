import ranger.api
import ranger.gui.widgets.browsercolumn
import stat
from ranger.ext.widestring import WideString

OldBrowserColumn = ranger.gui.widgets.browsercolumn.BrowserColumn

class BrowserColumn(OldBrowserColumn):

    def _draw_icon(self, drawn, tagged, tagged_marker):
        mark = u"\ue606"

        if tagged:
            tag_icons = {
                'h':u"\ue600", '*':u"\ue616", 'd':u"\ue60e",
                'g':u"\ue61e", 'c':u"\ue613", 's':u"\ue60f",
                'w':u"\ue627", 'o':u"\ue61b", 'i':u"\ue602",
                'a':u"\ue610",}
            if tagged_marker in tag_icons:
                mark = tag_icons[tagged_marker]
            else:
                mark = tagged_marker
        elif drawn.is_link:
            mark = u"\ue614"
        elif drawn.video:
            mark = u"\ue604"
        elif drawn.image:
            mark = u"\ue601"
        elif drawn.audio:
            mark = u"\ue603"
        elif drawn.container:
            mark = u"\ue60d"
        elif drawn.document:
            mark = u"\ue607"
        elif drawn.is_directory:
            mark = u"\ue609"
        elif drawn.stat and (drawn.stat.st_mode & stat.S_IXUSR):
            mark = u"\ue61c"

        mark += " "
        return mark.encode('utf-8')

    # OH GOD SO HACKY
    # I have to get the tag info and file to compute icon
    # so I rely on the order these functions are called
    def _draw_tagged_display(self, tagged, tagged_marker):
        self.this_tagged = tagged
        self.this_marker = tagged_marker
        return []

    def _draw_vcsstring_display(self, drawn):
        self.this_file = drawn
        struct = super(BrowserColumn,self)._draw_vcsstring_display(drawn)
        if drawn.is_directory and self.main_column:
            struct.append([u"\u203a ".encode('utf-8'),[]])
        return struct

    def _draw_text_display(self, text, space):
        mark = self._draw_icon(self.this_file, self.this_tagged, self.this_marker)

        wtext = WideString(mark) + WideString(text)
        wellip = WideString(self.ellipsis[self.settings.unicode_ellipsis])
        if len(wtext) > space:
            wtext = wtext[:max(0, space - len(wellip))] + wellip

        attrs = []
        if self.this_tagged:
            attrs.append('tagged')

        return [[str(wtext), []]]


# Finally, "monkey patch" the existing hook_ready function with our replacement:
ranger.gui.widgets.browsercolumn.BrowserColumn = BrowserColumn
