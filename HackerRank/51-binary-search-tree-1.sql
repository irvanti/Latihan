--this is query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

--Root: If node is root node.
--Leaf: If node is leaf node.
--Inner: If node is neither root nor leaf node.


--this is query from engineeringwitharavind  github
select n, case
            when p is null then 'Root'
            when exists (select n from bst where p = b.n) then 'Inner'
            else 'Leaf'
            end
from bst b
order by n;