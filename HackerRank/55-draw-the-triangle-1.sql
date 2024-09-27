--this is query to draw the triangle as descending stars

set @temp:=21;
select repeat('* ', @temp:= @temp - 1) 
from information_schema.tables;