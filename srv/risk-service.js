const cds = require('@sap/cds')

module.exports = cds.service.impl(async function () {

    const { Risks, BusinessPartners, Items } = this.entities;

    this.on("getItemsWithQuantity", async ({ data: { quantity } }) => {
        return await SELECT.from(Items).where({ quantity });
    });

    this.before("createItem", (req) => {
        const { quantity } = req.data;
        if (quantity > 100) {
            return req.error(409, `Item quantity cannot be more than 100.`);
        }
    });

    this.on("createItem", async ({ data: { title, descr, quantity } }) => {
        await INSERT({ descr, title, quantity }).into(Items);
    });

    this.after("READ", Risks, (data) => {
        const risks = Array.isArray(data) ? data : [data];

        risks.forEach((risk) => {
            if (risk.impact >= 100000) {
                risk.criticality = 1;
            } else {
                risk.criticality = 2;
            }


            switch (risk.prio_code) {
                case 'H':
                    risk.PrioCriticality = 1;
                    break;
                case 'M':
                    risk.PrioCriticality = 2;
                    break;
                case 'L':
                    risk.PrioCriticality = 3;
                    break;
                default:
                    break;
            }

        })
    })
});