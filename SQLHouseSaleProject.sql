/*
Cleaning Data in SQL Queries
*/

Select*
from PortfolioProject..NashvilleHousing

-- Standardize Date Format

Select SaleDateConverted, convert (date, Saledate)
from PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing 
Add SaleDateConverted date;

update NashvilleHousing
SET SaleDateConverted = convert (date, Saledate)

--CONVERT(varchar, SaleDate, 103)  For format dd/mm/yyyy


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
from PortfolioProject..NashvilleHousing
Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



Update a
Set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from PortfolioProject..NashvilleHousing




Select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, 
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City

from PortfolioProject..NashvilleHousing




ALTER TABLE NashvilleHousing 
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)




ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select *
from PortfolioProject..NashvilleHousing


Select OwnerAddress
from PortfolioProject..NashvilleHousing

Select
PARSENAME (REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME (REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME (REPLACE(OwnerAddress, ',','.'),1)
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing 
Add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress, ',','.'),3) 

ALTER TABLE NashvilleHousing 
Add OwnerSplitCity nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing 
Add OwnerSplitState nvarchar(255);

update NashvilleHousing
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress, ',','.'),1)


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, 
CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
     ELSE SoldAsVacant
	 END
from PortfolioProject..NashvilleHousing


Update NashvilleHousing

SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
     ELSE SoldAsVacant
	 END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
 Select *,
      ROW_NUMBER () OVER (
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				        UniqueID
						) row_num


from PortfolioProject..NashvilleHousing
--order by ParcelID
)


Select *
from RowNumCTE
WHERE row_num > 1
Order by PropertyAddress



WITH RowNumCTE AS (
 Select *,
      ROW_NUMBER () OVER (
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				        UniqueID
						) row_num


from PortfolioProject..NashvilleHousing
--order by ParcelID
)


DELETE
from RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate, SaleDateConv, SaleDateConv2