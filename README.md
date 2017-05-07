# XMLParser3
XML Parser in Swift3. Example runs from xml file till data is serialized to classes in your app memory.

![ScreenShot Social](/screenshot.png)

XML Parser to parse your data from an xml file and dynamically build
relevant classes from it in memory.
Red TextBox shows the XML to be parsed. You may also find it in project under
the name `tarantino.xml`. The blue TextBox shows you the Array in ViewController
filled with the data of the XML.
The parsing and serializing to real classes in runtime is done as parser emits
the invocation of the delegate `XMLParserDelegate` methods, especially these ones:

`didStartElement` - called when first bumping into element tag. Here, we will
extract the attributes (if any to be found), and allocate new `TarantinoFilm` class
instance in our array, provided the tag is 'film'. We'll also keep the last element name.

`foundCharacters` -  This babe is called when parser gets to "real" characters, namely
 values for the element tags. Therefore, that's the place to fill in the properties of
 the current film object we have allocated on didStartElement. We'll switch-case on the last element parsed to get
 the relevant properties ("lastElement" is being saved each didStartElement call)

 `parseErrorOccurred` - I recommend tampering the XML a bit to see this routine invocation. It it supplied with a special error code representing a specific error in XML Validation.

More:
 * See also remarks in code - they're explanatory.
 * Output window in runtime debug also show the XML and the result in a nice format
 * Mind the NumberFormatter usage to show large string numbers
 * See also advanced material on XML (Validity, DTD, DOM and more) in W3Schools site
 * And of course, as a devoted Tarantino fan, I highly recommend all the movies in the xml... :-)
