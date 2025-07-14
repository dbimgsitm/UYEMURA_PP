@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '생산 배치 채번 History view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_BATCHCOUNTING_H
  as select from ztgspp0010h as History
  association [0..*] to ZI_BATCHCOUNTING as _Main on $projection.Refhead = _Main.Id
{
  key History.id              as Id,
      History.refhead         as Refhead,
      History.ordernumber     as Ordernumber,
      History.postingdate     as Postingdate,
      History.status          as Status,
      History.material        as Material,
      History.manufacturedate as Manufacturedate,
      History.batch_count     as BatchCount,
      @Semantics.user.createdBy: true
      History.created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      History.created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      History.last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      History.last_changed_at as LastChangedAt,

      //Association
      _Main
}
