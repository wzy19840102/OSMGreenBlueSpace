# OSMGreenBlueSpace
A significant number of literature have shown that green and blue space are very important for physicial activities and health. Following this, in this project we focus on extracting green and bluce space from OpenStreetMap. The overall goal of this project is to integrate the information of the exposure to green and blue space into pedestrian navigation to facilitate pedestrian navigation. In general, all vegetated areas are considered as green space. It should be noted that these green areas can be further separated into public and private space as well as urban and rural space. 

Please follow the following steps: 

0) Install Postgresql (https://www.postgresql.org/) and PostGIS (https://postgis.net/)
1) Install Osmosis, https://wiki.openstreetmap.org/wiki/Osmosis and import OSM data into the database
2) Run the SQL file to extract green space. The file uses the tags, such as **nature** and **landuse**,  and finds the features with values that indicate green space. More information about the green space in OSM can be found at https://wiki.openstreetmap.org/wiki/Green_space_access_ITO_map.  
3) Run the SQL file to extract blue space. The file uses the tags, such as **nature** and **landuse**,  and finds the features with values that indicate green space. More information about the green space in OSM can be found at https://wiki.openstreetmap.org/wiki/Green_space_access_ITO_map.  

