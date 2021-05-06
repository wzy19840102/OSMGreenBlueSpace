# OSMGreenBlueSpace
A significant number of literature have shown that **green and blue space** are very important for physicial activities and health. Following this, in this project we focus on extracting green and bluce space from OpenStreetMap (https://www.openstreetmap.org/). The overall goal of this project is to integrate the information of the exposure to green and blue space into pedestrian navigation to facilitate physicial activities. In general, all vegetated areas are considered as green space. It should be noted that these green areas can be further separated into public and private space as well as urban and rural space. 


Blue space             |  Green space
:-------------------------:|:-------------------------:
<img width="600" height="500"  src="https://github.com/wzy19840102/OSMGreenBlueSpace/blob/main/fig/blue.jpg" /> |  <img width="600" height="500"   src="https://github.com/wzy19840102/OSMGreenBlueSpace/blob/main/fig/green.jpg" />
photo from https://unsplash.com/ |  photo from https://unsplash.com/ 


The following steps describe how to use the provided sql file to extract green and blue space features from OpenStreetMap: 

0\) Install Postgresql (https://www.postgresql.org/) and PostGIS (https://postgis.net/)
1\) Install Osmosis, https://wiki.openstreetmap.org/wiki/Osmosis and import OSM data into the database
2\) To extract green space,  the sql file uses the tags, such as **nature** and **landuse**,  and finds the features with values that indicate green space, e.g., natural=grassland. More information about the green space in OSM can be found at https://wiki.openstreetmap.org/wiki/Green_space_access_ITO_map.  
3\) To extract blue space, the file uses the tags, such as **nature** and **landuse**,  and finds the features with values that indicate blue space, e.g., natural=water. More information about the blue space in OSM can be found at https://wiki.openstreetmap.org/wiki/Tag:natural%3Dwater.   

