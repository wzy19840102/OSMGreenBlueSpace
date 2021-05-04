# OSMGreenBlueSpace
Green and blue space play an importtant role in physicial activities and health. In this project, we focus on extracting green and bluce space from OpenStreetMap. 
Please follow the following steps: 

0) Install Postgresql (https://www.postgresql.org/) and PostGIS (https://postgis.net/)
1) Install Osmosis, https://wiki.openstreetmap.org/wiki/Osmosis and import OSM data into the database
2) Run the SQL file to extract green and blue space. The file uses the tags, such as **nature** and **landuse**,  and finds the features with values that indicate green space. More information about the green space in OSM can be found at https://wiki.openstreetmap.org/wiki/Green_space_access_ITO_map.  

