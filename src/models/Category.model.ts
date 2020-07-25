import { Model, Column, Table, PrimaryKey, CreatedAt, AutoIncrement, BelongsTo, ForeignKey } from "sequelize-typescript";
import CategoryGroup from "./CategoryGroup.model";

@Table({ updatedAt: false })
export default class Category extends Model<Category> {
    @AutoIncrement
    @PrimaryKey
    @Column
    id: number;

    @Column
    name: string;

    @ForeignKey(() => CategoryGroup)
    @Column
    categoryGroupId: number;

    @BelongsTo(() => CategoryGroup)
    categoryGroup: CategoryGroup;

    @CreatedAt
    createdAt: Date;
}