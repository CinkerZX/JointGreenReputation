function categoryAveJR = helperCategoryAveJR(categoryCurrentNodes, supplierAveJR, manufacturerAveJR, retailerAveJR)
    switch categoryCurrentNodes
        case 1
            categoryAveJR = supplierAveJR;
        case 2
            categoryAveJR = manufacturerAveJR;
        otherwise
            categoryAveJR = retailerAveJR;
    end
end