USE [TicketingDb]
GO
/****** Object:  StoredProcedure [dbo].[GetAllDepartments]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetAllDepartments]
 @PageNumber INT,
 @PageSize INT,
 @Query nvarchar(MAX),
 @totalrow INT  OUTPUT
AS
BEGIN
	SELECT 
		 D.[Id]
		,D.[Title]
		,D.[Description]
		,D.[IsDeleted] AS IsDeleted
		,DT.[Title] AS DepartmentTitle
		,C.[Title] AS CompanyTitle
	FROM Departments AS D
	JOIN DepartmentTypes AS DT
	ON DT.Id = D.DepartmentTypeId
	JOIN Companies AS C
	ON C.Id = D.CompanyId
	
	FROM Departmets 
	WHERE D.IsDeleted = 0 AND [Title] LIKE N'%'+@Query+'%'
		ORDER BY Id DESC
	OFFSET ((@PageNumber - 1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY
	SET @totalrow = (SELECT COUNT(*) FROM Departments WHERE IsDeleted = 0 AND D.[Title] LIKE N'%'+@Query+'%')
END

INSERT INTO table_name (
			row_names
		)
	VALUES (
		row_new_values
	)

-- or

UPDATE table_name
SET column_name_1 = new_value, ...
WHERE my_id = 4012035009
