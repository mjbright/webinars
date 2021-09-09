#!/usr/bin/env python3

import xml.dom.minidom, sys

# or xml.dom.minidom.parseString(xml_string):
dom = xml.dom.minidom.parse(sys.argv[1])

pretty_xml_as_string = dom.toprettyxml()
print( pretty_xml_as_string )


