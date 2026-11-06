p = r"D:\indirilenler\Yeni klasor43\ios\Runner.xcodeproj\project.pbxproj"
s = open(p, "r", encoding="utf-8").read()

old = """97C147021CF9000F007C117D /* Info.plist */ = {
		97C147061CF9000F007C117D /* GoogleService-Info.plist */ = {
	isa = PBXFileReference;
	lastKnownFileType = text.plist.xml;
	path = GoogleService-Info.plist;
	sourceTree = "<group>";
};
isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };"""

new = """97C147021CF9000F007C117D /* Info.plist */ = {
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
};"""

if old in s:
    s = s.replace(old, new)
    with open(r"D:\indirilenler\Yeni klasor43\ios\Runner.xcodeproj\project.pbxproj", "w", encoding="utf-8") as f:
        f.write(s)
    print("Fixed!")
else:
    print("Exact pattern not found")
    import re
    pattern = re.compile(r"97C147021CF9000F007C117D /\* Info\.plist \*/ = \{[^}]*97C147061CF9000F007C117D /\* GoogleService-Info\.plist \*/ = \{[^}]*isa = PBXFileReference; lastKnownFileType = text\.plist\.xml; path = Info\.plist; sourceTree = \"<group>\"; \};", re.DOTALL)
    match = re.search(pattern, s)
    if match:
        print("Found with regex, length:", len(match.group()))
        print(repr(match.group()[:200]))
    else:
        print("Not found with regex either")