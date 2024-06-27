using {riskmanagement as rm} from '../db/schema';

@path: 'service/risk'
service RiskService {
    entity Risks       as projection on rm.Risks;
    annotate Risks with @odata.draft.enabled;

    entity Mitigations as
        projection on rm.Mitigations {
            *,
            risks : redirected to Risks
        };

    annotate Mitigations with @odata.draft.enabled;

    @readonly
    entity ListOfRisks as
        select from rm.Risks {
            ID,
            title,
            owner
        }

    entity Items as projection on rm.Items;

    function getItemsWithQuantity(quantity : Integer) returns array of Items;
    action createItem(title : String, descr : String, quantity : Integer);

// BusinessPartner will be used later
//@readonly entity BusinessPartners as projection on rm.BusinessPartners;
}
