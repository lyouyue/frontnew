package cms.information.pojo;

import util.pojo.BaseEntity;


/**
 * 信息分类表
 * @author FuLei
 *
 */

public class CmsInformationCategory extends BaseEntity   implements java.io.Serializable {
   
	private static final long serialVersionUID = -8320570889054082472L;
	/**
	 * 分类id
	 */
	private Integer InformationCategoryId;
	/**
	 * 分类名称
	 */
	private String categoryName;
	/**
	 * 当前表的父分类id
	 */
	private Integer parentId;
	/**
	 * 排序
	 */
	private Integer sortCode;
	/**
	 * seo关键词
	 */
	private String keywords;
	/**
	 * 是否为叶子  ，1是叶子，0 不是叶子
	 */
	private Integer isLeaf;
	public Integer getInformationCategoryId() {
		return InformationCategoryId;
	}
	public void setInformationCategoryId(Integer informationCategoryId) {
		InformationCategoryId = informationCategoryId;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	public Integer getSortCode() {
		return sortCode;
	}
	public void setSortCode(Integer sortCode) {
		this.sortCode = sortCode;
	}
	public String getKeywords() {
		return keywords;
	}
	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}
	public Integer getIsLeaf() {
		return isLeaf;
	}
	public void setIsLeaf(Integer isLeaf) {
		this.isLeaf = isLeaf;
	}

	
}