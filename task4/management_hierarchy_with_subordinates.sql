-- management_hierarchy_with_subordinates.sql
-- Рекурсивно строит иерархию менеджеров, 
-- включая информацию о проектах, задачах и количестве подчиненных,
-- отображая только менеджеров с подчиненными.

WITH RECURSIVE EmployeeHierarchy AS (
    SELECT 
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    JOIN Roles r ON e.RoleID = r.RoleID
    WHERE r.RoleName = 'Менеджер'

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    JOIN Roles r ON e.RoleID = r.RoleID
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT 
    eh.EmployeeID,
    eh.EmployeeName,
    eh.ManagerID,
    eh.DepartmentName,
    eh.RoleName,
    GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName) AS ProjectNames,
    GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName) AS TaskNames,
    (SELECT COUNT(*) FROM EmployeeHierarchy eh2 WHERE eh2.ManagerID = eh.EmployeeID) AS TotalSubordinates
FROM EmployeeHierarchy eh
LEFT JOIN Projects p ON p.DepartmentID = (SELECT DepartmentID FROM Employees WHERE EmployeeID = eh.EmployeeID)
LEFT JOIN Tasks t ON t.AssignedTo = eh.EmployeeID
GROUP BY eh.EmployeeID, eh.EmployeeName, eh.ManagerID, eh.DepartmentName, eh.RoleName
HAVING TotalSubordinates > 0
ORDER BY eh.EmployeeName;