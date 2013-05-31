<%
    String key = request.getParameter("key");
%>

<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <script src="http://open.mapquestapi.com/sdk/js/v7.0.s/mqa.toolkit.js"></script>

    <script type="text/javascript">

        /*An example of using the MQA.EventUtil to hook into the window load event and execute defined function
         passed in as the last parameter. You could alternatively create a plain function here and have it
         executed whenever you like (e.g. <body onload="yourfunction">).*/

        MQA.EventUtil.observe(window, 'load', function() {

            /*Create an object for options*/
            var options={
                elt:document.getElementById('map'),        /*ID of element on the page where you want the map added*/
                zoom:10,                                   /*initial zoom level of map*/
                latLng:{lat:39.2833, lng:-76.6167},    /*center of map in latitude/longitude*/
                mtype:'osm'                                /*map type (osm)*/
            };

            /*Construct an instance of MQA.TileMap with the options object*/
            window.map = new MQA.TileMap(options);

            /*Downloads and enables support modules for MQA.RemoteCollection and the MQA.GeoKMLDeserializer. The MQA.KMLDeserializer
             can also create InfoWindows if the data is supplied. This example uses a KML feed to create shapes.*/

            MQA.withModule('largezoom','dotcomwindowmanager','remotecollection','kmldeserializer', 'viewoptions', function() {
                var locations = new MQA.RemoteCollection('locationData/<%=key%>',new MQA.KMLDeserializer());
                locations.collectionName='metro lines';

                console.log(locations.loaded);

                MQA.EventManager.addListener(locations,'loaded',function(e){
                    map.addControl(
                            new MQA.LargeZoom(),
                            new MQA.MapCornerPlacement(MQA.MapCorner.TOP_LEFT, new MQA.Size(5,5))
                    );



                    map.setZoomLevel(12);
                    console.log(locations.loaded);
                    console.log(locations.items);

                    for(var index = 0; index < locations.items.length; index++) {
                        setupItem(locations.items[index]);
                    }

                });

                console.log(locations.items);

                map.addShapeCollection(locations);

            });
        });

        function setupItem(item)
        {
            var description = item.getInfoContentHTML();
            var name = item.getInfoTitleHTML();
            item.setIcon(new MQA.Icon("images/<%=key%>.png",32,32));

            item.setRolloverContent(name);
            item.setInfoContentHTML("<div class='itemBubble'><span class='itemName'>" + name  + "</span><br/><span class='itemDescription'>" + description + "</span></div>")
            item.setDeclutterMode(true);

            //console.log(item.getIcon());
        }

    </script>
</head>

<body>
<div id='map' style='width:750px; height:750px;'></div>
</body>
</html>

