-- employee_hierarchy_with_detailed_info.sql
-- Рекурсивно извлекает иерархию сотрудников, начиная с менеджера с ID 1,
-- включая информацию о проектах, задачах, общем количестве задач и подчиненных.

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
    WHERE e.ManagerID = 1

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
    COUNT(t.TaskID) AS TotalTasks,
    (SELECT COUNT(*) FROM Employees e WHERE e.ManagerID = eh.EmployeeID) AS TotalSubordinates
FROM EmployeeHierarchy eh
LEFT JOIN Projects p ON p.DepartmentID = (SELECT DepartmentID FROM Employees WHERE EmployeeID = eh.EmployeeID)
LEFT JOIN Tasks t ON t.AssignedTo = eh.EmployeeID
GROUP BY eh.EmployeeID, eh.EmployeeName, eh.ManagerID, eh.DepartmentName, eh.RoleName
ORDER BY eh.EmployeeName;