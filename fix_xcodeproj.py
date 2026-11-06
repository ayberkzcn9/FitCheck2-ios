import re

p = r"D:\indirilenler\Yeni klasor43\ios\Runner.xcodeproj\project.pbxproj"
s = open(p, "r", encoding="utf-8").read()

# Fix the malformed Info.plist / GoogleService-Info.plist file reference section
old = '''		97C147021CF9000F007C117D /* Info.plist */ = {
	97C147061CF9000F007C117D /* GoogleService-Info.plist */ = {
	isa = PBXFileReference;
	lastKnownFileType = text.plist.xml;
	path = GoogleService-Info.plist;
	sourceTree = "<group>";
};
isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };'''

new = '''		97C147021CF9000F007C117D /* Info.plist */ = {
	isa = PBXFileReference;
	lastKnownFileType = text.plist.xml;
	path = Info.plist;
	sourceTree = "<group>";
};
		97C147061CF9000F007C117D /* GoogleService-Info.plist */ = {
	isa = PBXFileReference;
	lastKnownFileType = text.plist.xml;
	path = GoogleService-Info.plist;
	sourceTree = "<group>";
};'''

if old in s:
    s = s.replace(old, new)
    open(p, "w", encoding="utf-8").write(s)
    print("Fixed")
else:
    print("Pattern not found")