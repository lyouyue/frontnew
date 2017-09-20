package shop.product.service;
import java.util.List;
import java.util.Map;
import shop.product.pojo.ProductInfo;
import shop.product.pojo.ProductType;
import util.service.IBaseService;
/**
 * 套餐分类Service接口
 * 
 *
 */
@SuppressWarnings("unused")
public interface IProductTypeService  extends IBaseService <ProductType> {
	/**
	 * 修改父亲的节点状态为2
	 * 1：叶子：显示删除
       2：非叶子：不显示删除
	 * @param productTypeId   套餐分类ID
	 */
	public void saveOrUpdateFatherLoadType(String productTypeId);
	/**
	 * 根据父ID查询子列表
	 * 
	 * @param id 套餐分类父ID
	 * 
	 * @return 返回一个list集合
	 */
	@SuppressWarnings("unchecked")
	public List queryByParentId(String id);
	/**
	 * 获取分类下品牌
	 * @param productTypeId
	 * 			套餐分类的ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List queryBrandByProductTypeId(Integer productTypeId);
	/**
	 * 获取规格数据
	 * @param productTypeId
	 * 			套餐分类ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, List> getSpecification(Integer productTypeId);
	/**
	 * 产品列表-分类展示
	 */
	public List<ProductType> getProductTypeDir(Integer productTypeId);
}
