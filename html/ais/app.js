
  var mymap = L.map('mymap').setView([53.227, -8.8], 6);
  L.tileLayer('https://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(mymap);
  var mmsi_layers = {};
  var myMmsis = L.layerGroup([]).addTo(mymap);
  var otherMmsis = L.layerGroup([]);
  var overlays = {
    "My MMSIs": myMmsis,
    "Other MMSIs": otherMmsis
  };
  L.control.layers([], overlays).addTo(mymap);

  document.getElementById("login").addEventListener('submit',function(e){
               if (e.preventDefault) e.preventDefault();
               connectOrReconnect();
               return false;
         });
         var ais_topics = ["ais-rinville-1-geojson","ais-belmullet-geojson"];
         var wanted_mmsis = JSON.parse(localStorage.getItem("wanted_mmsis") || "[]");
         if(wanted_mmsis.length == 0){
           otherMmsis.addTo(mymap);
         }
         var rememberUserMMSI = function(mmsi){
           if(wanted_mmsis.indexOf(mmsi)<0){
             wanted_mmsis.push(mmsi);
             localStorage.setItem("wanted_mmsis",JSON.stringify(wanted_mmsis));
             if(mmsi_layers[mmsi]){
               otherMmsis.removeLayer(mmsi_layers[mmsi]);
               mmsi_layers[mmsi].addTo(myMmsis);
             }
           }
         }
         var forgetUserMMSI = function(mmsi){
           var i = wanted_mmsis.indexOf(mmsi);
           if(i>-1){
             wanted_mmsis.splice(i,1);
             localStorage.setItem("wanted_mmsis",JSON.stringify(wanted_mmsis));
             if(mmsi_layers[mmsi]){
               myMmsis.removeLayer(mmsi_layers[mmsi]);
               mmsi_layers[mmsi].addTo(otherMmsis);
             }
           }

         }

        var connectOrReconnect = function(){
               var username = document.querySelector('.username').value;
               var password = document.querySelector('.password').value;
               document.getElementById("login").classList.add("hidden");
               document.getElementById("errors").textContent = "";
               doconnect(ais_topics,username,password);
        };

        var showlogin = function(){
          var form = document.getElementById("login");
          form.classList.remove("hidden");
        }

        var client;
        var doconnect = function(topics,username,password){
           if(client){
              client.end(true);
              client = null;
           }
           if(username){
              client = mqtt.connect("wss://mqtt.marine.ie",{username: username, password: password});
           }else{
              client = mqtt.connect("wss://mqtt.marine.ie");
           }
           client.on("message", function(topic, payload) {
             document.getElementById("errors").textContent = "";
                 var el = document.getElementById(topic);
                 if(!el){
                   el = document.createElement('div');
                   el.id = topic;
                   document.body.appendChild(el);
                 }
                 if(ais_topics.indexOf(topic) >= 0){
                   handle_geojson(JSON.parse(payload));
                 }else{
                   el.textContent = payload;
                 }
            });
           client.on('connect', function(err) {
             document.getElementById("errors").textContent = "Waiting for data...";
           });
           client.on('close', function(e){
             document.getElementById("errors").textContent = "Connection closed...";
             connectOrReconnect();
           });
           client.on('error', function(err) {
             document.getElementById("errors").textContent = err.toString();
             showlogin();
           });
           for(var i=0;i<topics.length;i++){
              client.subscribe(topics[i]);
           }
        }
        showlogin();
		var markerIcon = function(name){
				return L.icon({
            iconUrl: name + "Marker.png",
            iconSize: [30, 36], // size of the icon
            iconAnchor: [15, 36], // point of the icon which will correspond to marker's location
            popupAnchor: [6, 0] // point from which the popup should open relative to the iconAnchor
        });
		}
        var ShipIcon = markerIcon("Ship") ;
        var HeliIcon = markerIcon( "Heli");
        var BaseIcon = markerIcon("Ais");
        var LighthouseIcon = markerIcon("Lighthouse");
		
        var updateDisplayStatus = function(el){
          var mmsi = el.getAttribute('mmsi');
          if(el.checked){
            rememberUserMMSI(mmsi);
          }else{
            forgetUserMMSI(mmsi);
          }
        }

        var featureMap = {
            pointToLayer: function (feature, latlng) {
                var aisMarker = L.marker(latlng, { title: feature.properties.shipname || feature.properties.name } );

                if (typeof feature.properties.aid_type != 'undefined') {
                    //Navigation Aid (Lighthouse / Buoy)
                    aisMarker = L.marker(latlng, { icon: LighthouseIcon, title: feature.properties.name });
                }
                else if (typeof feature.properties.type == 9) {
                    //SAR Aircraft
                    aisMarker = L.marker(latlng, { icon: HeliIcon, title: feature.properties.shipname });
                }
                else if (typeof feature.properties.shiptype != 'undefined') {
                    //Vessels
                    if (feature.properties.shiptype == 51) {
                        //SAR Aircraft
                        aisMarker = L.marker(latlng, { icon: HeliIcon, title: feature.properties.shipname });
                    }
                    else {
                        //Ship
                        aisMarker = L.marker(latlng, { icon: ShipIcon, title: feature.properties.shipname });
                    }
                }
                else if (feature.properties.type == 4) {
                    //Base Station
                    aisMarker = L.marker(latlng, { icon: BaseIcon, title: feature.properties.shipname });
                }
                return aisMarker;
            },

            onEachFeature: function (feature, layer) {
                var name = typeof feature.properties.shipname != 'undefined' ? feature.properties.shipname : feature.properties.name != undefined ? feature.properties.name : "No Name";
                var dest = "";
                if (typeof feature.properties.destination != 'undefined') {
                    dest = "<br><b>destination:</b> " + feature.properties.destination;
                }
                var popupOptions = { maxWidth: 200 };
                var mmsi = feature.properties.mmsi;
                var data = JSON.stringify(feature.properties,Object.keys(feature.properties).sort(),2);
                var checked = wanted_mmsis.indexOf(""+mmsi)>-1;
                var text = feature.properties.shiptype_text || feature.properties.light_text || "";
                var p = document.createElement('p');
                p.textContent = text;
                text = p.innerHTML?(p.innerHTML+"<br>"):"";
                layer.bindPopup("<b>" + name + "</b>" + dest + "<br><b>mmsi:</b> " + feature.properties.mmsi + "<br>"+text+"(" + feature.properties.mi_timestamp + ")<br><label>My MMSIs?</label>"
                +"<input type='checkbox' mmsi='"+mmsi+"'"+(checked?" checked":"")+" onchange='updateDisplayStatus(this);'><br>"
                +"<a href='#' onclick='copy(this);return false;'>copy details to clipboard</a><textarea hidden>"+data+"</textarea>", popupOptions);
            }

        };

		
		var live_data = {};
		var live = true;
        var handle_geojson = function(x){
          var mmsi = x.properties.mmsi;
		  var old = live? (live_data[mmsi] || x) : x;
		  x._mipaths = old._mipaths || [new L.LatLng(x.geometry.coordinates[1],x.geometry.coordinates[0])];
		  x._mipathtimes = old._mipathtimes || [new Date().getTime()];

		 var latlng = new L.LatLng(x.geometry.coordinates[1],x.geometry.coordinates[0]);
            if(latlng.distanceTo(x._mipaths[0])>50){ //meters
              x._mipaths.unshift(latlng);
			   x._mipathtimes.unshift(new Date().getTime());
            }
		 if(live){
                      if(faders[mmsi]) clearTimeout(faders[mmsi]);
                      live_data[mmsi] = x;
		      update_map(x);
                      // fade this out after some minutes if no new data...
                      faders[mmsi] = setTimeout(do_fade, 20*60*1000, mmsi);
		 }
	  }
	var update_map = function(x){
          var mmsi = x.properties.mmsi;
          var oldlayer = mmsi_layers[mmsi];
          var layer = L.layerGroup([L.geoJSON(x,featureMap)]);
          mmsi_layers[mmsi] = layer;
			
          var baselayer = wanted_mmsis.indexOf(""+mmsi)<0?otherMmsis:myMmsis;
          layer.addTo(baselayer);
          if(oldlayer){
            baselayer.removeLayer(oldlayer);
		  }
          if(x._mipaths.length > 1){
                var pathOptions = {delay: 400, dashArray: [10,20], weight: 5, color: "#0000FF", pulseColor: "#FFFFFF", reverse: true};
                var taillayer = L.polyline.antPath(x._mipaths, pathOptions);
                taillayer.addTo(layer);
          }
        }
  
        function copy(el) {
            var tempInput = document.createElement("textarea");
            tempInput.style = "position: absolute; left: -1000px; top: -1000px";
            tempInput.value = el.nextSibling.value;
            document.body.appendChild(tempInput);
            tempInput.select();
            document.execCommand("copy");
            document.body.removeChild(tempInput);
            el.innerText='Copied!';
        }
var faders = {};
var fade_timeout = 1000;

var end_fade = function(mmsi){
   var layer = mmsi_layers[mmsi];
   if(layer){
      myMmsis.removeLayer(layer);
      otherMmsis.removeLayer(layer);
   }
   delete faders[mmsi];
   delete mmsi_layers[mmsi];
}

var do_fade = function(mmsi){
   var layer = mmsi_layers[mmsi];
   if(!layer){
       delete faders[mmsi];
       return;
    }
   var opacity = (layer._opacity || 1.01) - 0.1;
   // TODO: investigate, as this is not actually working
   layer.invoke("setStyle",{opacity: opacity, fillOpacity: opacity});
   layer.invoke("setOpacity",opacity);
   layer._opacity = opacity;
   if(opacity < 0.1){
      faders[mmsi] = setTimeout(end_fade,fade_timeout,mmsi);
   }else{
      faders[mmsi] = setTimeout(do_fade,fade_timeout,mmsi);
   }
}
