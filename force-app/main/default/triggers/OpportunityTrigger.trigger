
trigger OpportunityTrigger on Opportunity (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    if (Trigger.isBefore) {
        OpportunityTriggerBeforeHandler handler = new OpportunityTriggerBeforeHandler();

        if (Trigger.isInsert) {
            handler.onBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            handler.onBeforeUpdate(
                Trigger.new,
                Trigger.oldMap
            );
        } else if (Trigger.isDelete) {
            handler.onBeforeDelete(
                Trigger.old
            );
        }
    }

    if (Trigger.isAfter) {
        OpportunityTriggerAfterHandler afterHandler =
            new OpportunityTriggerAfterHandler();

        if (Trigger.isInsert) {
            afterHandler.onAfterInsert(
                Trigger.new
            );
        } else if (Trigger.isUpdate) {
            afterHandler.onAfterUpdate(
                Trigger.new,
                Trigger.oldMap
            );
        } else if (Trigger.isDelete) {
            afterHandler.onAfterDelete(
                Trigger.old
            );
        } else if (Trigger.isUndelete) {
            afterHandler.onAfterUndelete(
                Trigger.new
            );
        }
    }
}