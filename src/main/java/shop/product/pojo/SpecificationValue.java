package shop.product.pojo;
import java.io.Serializable;
import util.pojo.BaseEntity;
/**
 * SpecificationValue - 套餐规格值实体类
 */
public class SpecificationValue extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 1L;
	/**
	 * 套餐规格值ID
	 */
	private Integer specificationValueId;
	/**
	 * 套餐规格ID
	 */
	private Integer specificationId;
	/**
	 * 套餐规格名称
	 */
	private String name;
	/**
	 * 套餐规格图片
	 */
	private String image;
	/**
	 * 套餐规格值排序
	 */
	private Integer sort;
	/**
	 * 套餐ID
	  */
	private Integer productId;
	
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public Integer getSpecificationValueId() {
		return specificationValueId;
	}
	public void setSpecificationValueId(Integer specificationValueId) {
		this.specificationValueId = specificationValueId;
	}
	public Integer getSpecificationId() {
		return specificationId;
	}
	public void setSpecificationId(Integer specificationId) {
		this.specificationId = specificationId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
	}
}
