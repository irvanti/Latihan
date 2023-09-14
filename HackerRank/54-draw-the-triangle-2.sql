--this is query to draw the triangle as ascending

et @temp:=0; 
select repeat('* ', @temp:= @temp + 1) 
from information_schema.tables
where @temp < 20;