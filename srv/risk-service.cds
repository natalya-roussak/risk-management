using {riskmanagement as rm} from '../db/schema';

@path: 'service/risk'
service RiskService @(requires: 'authenticated-user') {
    entity Risks @(restrict: [
        {
            grant: 'READ',
            to   : 'RiskViewer'
        },
        {
            grant: [
                'READ',
                'WRITE',
                'UPDATE',
                'UPSERT',
                'DELETE'
            ], // Allowing CDS events by explicitly mentioning them
            to   : 'RiskManager',
            where: 'createdBy = $user'
        }
    ])                      as projection on rm.Risks;

    annotate Risks with @odata.draft.enabled;

    entity Mitigations @(restrict: [
        {
            grant: 'READ',
            to   : 'RiskViewer'
        },
        {
            grant: '*', // Allow everything using wildcard
            to   : 'RiskManager'
        }
    ])                      as
        projection on rm.Mitigations {
            *,
            risks : redirected to Risks
        };

    annotate Mitigations with @odata.draft.enabled;

    @readonly
    entity ListOfRisks      as
        select from rm.Risks {
            ID,
            title,
            owner
        };

    entity Items            as projection on rm.Items;
    function getItemsWithQuantity(quantity : Integer) returns array of Items;
    action   createItem(title : String, descr : String, quantity : Integer);
    function getString()                              returns String;
    function getProductsFromNorthwind()               returns array of String;

    @readonly
    entity BusinessPartners as projection on rm.BusinessPartners;
}
