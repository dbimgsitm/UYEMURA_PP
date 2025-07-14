@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '생산 배치 채번 Interface view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_BATCHCOUNTING
  as select from ztgspp0010 as Main
  association [0..*] to ZI_BATCHCOUNTING_H as _History on $projection.Id = _History.Refhead
{
  key Main.id              as Id,
      Main.material        as Material,
      Main.manufacturedate as Manufacturedate,
      Main.batch_count     as BatchCount,
      @Semantics.user.createdBy: true
      Main.created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Main.created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Main.last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Main.last_changed_at as LastChangedAt,

      //Association
      _History
}
